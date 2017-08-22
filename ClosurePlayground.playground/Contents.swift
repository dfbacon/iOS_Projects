//: Playground - noun: a place where people can play

import UIKit

func downloadFileFromURL(url: NSURL, completionHandler: (Bool) -> Void) {
    // NSURL logic code & download. (return false/true)
    // Download has been completed
    completionHandler(true)
}

// before the function downloadFileFromURL is called, the NSURL logic code/download is run and will reach the true completion handler only if it succeeds

downloadFileFromURL(url: NSURL(string: "abc")!, completionHandler: { isSuccessful -> Void in
    if isSuccessful {
    print("You've downloaded")
    } else {
        print("error")
    }
})

var completionHandlers: [() -> Void] = []

// create a function that inserts a closure into the completionHandlers array.

// BELOW IS AN EXAMPLE THAT DOESN'T WORK
//func functionWithCompletionHandler(block: () -> Void) {
//    completionHandlers.append(block)
//}

// WORKING VERSION USING @ESCAPE
func functionWithCompletionHandler(block: @escaping () -> Void) {
    completionHandlers.append(block)
}

functionWithCompletionHandler(block: { print("hello") })

completionHandlers[0]()