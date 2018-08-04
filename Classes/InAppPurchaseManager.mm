#import "InAppPurchaseManager.h"
#import "Constants.h"
#import "GamePlayConfig.h"

@implementation InAppPurchaseManager

static InAppPurchaseManager * _sharedHelper;

+ (InAppPurchaseManager *) sharedHelper {

    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppPurchaseManager alloc] init];
    return _sharedHelper;
}

- (void)requestProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:IN_STORE_PURCHASE_ID];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    // we will release the request object in the delegate callback
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    product = [products count] == 1 ? [[response.products objectAtIndex:0] retain] : nil;
    if (product)
    {
        NSLog(@"Product title: %@" , product.localizedTitle);
        NSLog(@"Product description: %@" , product.localizedDescription);
        NSLog(@"Product price: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }

    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }

    // finally release the request we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
}

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    // get the product description (defined in early sections)
    [self requestProductData];
}


//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchase
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:IN_STORE_PURCHASE_ID];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"setting the purchase flag: %@", transaction.payment.productIdentifier);
    [[GamePlayConfig instance] purchaseGame];
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    NSLog(@"finishTransaction");
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}


//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction");
    [self recordTransaction:transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction");
    [self recordTransaction:transaction.originalTransaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}


//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled
        [self finishTransaction:transaction wasSuccessful:NO];

        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                NSLog(@"UNKNOWN TRANSACTION! %@", [transaction description]);
                break;
        }
    }
}

- (void)dealloc {
    [productsRequest release];
    [product release];
    [_sharedHelper release];
    [super dealloc];
}

@end
