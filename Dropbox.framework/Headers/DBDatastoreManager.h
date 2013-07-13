/* Copyright (c) 2013 Dropbox, Inc. All rights reserved. */

#import "DBAccount.h"
#import "DBDatastore.h"
#import "DBError.h"


/** The datastore manager lets you list, create, open, and delete datastores. You can
 also add an observer to find out when the list of datastores changes.
*/
@interface DBDatastoreManager : NSObject

/** Gets the datastore manager for an account that has been linked via the account manager.

 Mulitple calls with the same account will return the same object, unless you call <shutDown> or
 the account is unlinked. */
+ (DBDatastoreManager *)managerForAccount:(DBAccount *)account;

/** Opens the default datastore for this account, or creates it if it doesn't exist.
 
 @return The default datastore if successful, or `nil` if an error occurred. */
- (DBDatastore *)openDefaultDatastore:(DBError **)error;

/** List the IDs of all known datastores for the user, including the default datastore if it has
 been created.

 @return A list of datastore IDs as strings if successful, or `nil` if an error occurred. */
- (NSArray *)listDatastoreIds:(DBError **)error;

/** Open an existing datastore by its ID.

 The same datastore can't be opened more than once.
 
 @return The datastore with the given ID if successful, or `nil` if an error occurred. */
- (DBDatastore *)openDatastore:(NSString *)datastoreId error:(DBError **)error;

/** Creates and opens a new datastore with a unique ID.

 @return The newly created datastore, or `nil` if an error occcurred. */
- (DBDatastore *)createDatastore:(DBError **)error;

/** Deletes a datastore with the given ID.

 You must close open datastores before deleting them. The default datastore can never be deleted.
 This method will block until the deletion happens on the server, so you must be online for it to
 succeed and it should never be called from the main UI thread.

 @return YES if the datastore was deleted, or NO if an error occurrred. */
- (BOOL)deleteDatastore:(NSString *)datastoreId error:(DBError **)error;

/** Add a block to be called when a datastore is added or removed.

 Observers will always be called in the main thread. */
- (void)addObserver:(id)obj block:(DBObserver)block;

/** Remove all blocks associated with the given observer. */
- (void)removeObserver:(id)obj;

/** Shuts down the datastore manager, which stops all syncing.

 The datastore manager will be automatically shut down if the app is unlinked remotely. */
- (void)shutDown;

/** Whether the datastore manager is current shut down. */
@property (nonatomic, readonly, getter=isShutDown) BOOL shutDown;

@end
