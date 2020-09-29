//
//  DVMPokemonController.m
//  Pokedex-C
//
//  Created by Karl Pfister on 5/4/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

#import "DVMPokemonController.h"

static NSString * const baseURLString = @"https://pokeapi.co/api/v2/pokemon/";

@implementation DVMPokemonController

+ (void)fetchPokemonForSearchTerm:(NSString *)searchTerm completion:(void (^)(DVMPokemon *_Nullable))completion
{
    // Step 1) - Creste the URL from the Base URL and search term
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *finalURL = [baseURL URLByAppendingPathComponent:[searchTerm lowercaseString]];

    // Print the URL for testing <3
    NSLog(@"%@", finalURL);

    // Step 2) - Start my dataTask with the Completion

    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        // Was there an error
        if (error)
        {
            NSLog(@"There was an error in %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            return completion(nil);
        }
        // Check the response
        if (response)
        {
            NSLog(@"%@", response);
        }
        // Get the data
        if (!data)
        {
            NSLog(@"No data was found.");
            return completion(nil);
        }
        
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error: &error];
        
        if (!topLevelDictionary)
        {
            NSLog(@"Error parsing the JSON: %@", error);
            return completion(nil);
        }
        // If we made it here then I have succedfully parsed my JSON and should be able to complete with a Pokemon Object
        DVMPokemon *pokemon = [[DVMPokemon alloc] initWithDictionary:topLevelDictionary];
        completion(pokemon);
        
    }] resume];
}

+ (void)fetchSpriteImageForPokemon:(DVMPokemon *)pokemon completion:(void (^)(UIImage *))completion
{
    NSURL *imageURL = [NSURL URLWithString:pokemon.spritePath];
    NSLog(@"%@", imageURL);

    [[NSURLSession.sharedSession dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
         if (error)
               {
                   NSLog(@"%@", error);
                   return completion(nil);
               }

               if (!data)
               {
                   NSLog(@"%@", error);
                   return completion(nil);
               }

               UIImage *image = [UIImage imageWithData:data];
               completion(image);
    }] resume];
}
@end
