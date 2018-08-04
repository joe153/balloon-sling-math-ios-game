//
#import "PopBalloonDao.h"


@implementation PopBalloonDao

NSString *const fileName = @"popballoon.sqlite";


- (id)init {
    [self createEditableCopyOfDatabaseIfNeeded];
    return self;
}

- (void)saveScores:(NSString *)name :(int)level :(int)score {

    sqlite3 *database;

    // The database is stored in the application bundle.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];

    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        static sqlite3_stmt *compiledStatement;

        NSString *sql = [NSString stringWithFormat:@"insert into scores (name, level, score) values ('%@', '%i', '%i')", name, level, score];
        sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);

}


- (NSMutableArray *)topScores {

    NSMutableArray *scores = [[[NSMutableArray alloc] init] autorelease];

    sqlite3 *database;

    // The database is stored in the application bundle.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        const char *sql = "select name, level, score from scores order by score desc limit 10";

        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {

            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSString *name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                NSString *level = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                NSString *score = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];

//                Score *s = [[[Score alloc] init] autorelease];
//                s.level = level;
//                s.name = name;
//                s.score = score;
//                [scores addObject:s];

            }
            sqlite3_finalize(statement);
        } else {
            sqlite3_close(database);
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
    }
    sqlite3_close(database);

    return scores;
}


// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {

    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    [fileManager release];
}


- (void)dealloc {
    [super dealloc];  // Deallocate the super class.
}

@end