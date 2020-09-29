//
//  DVMPokemon.m
//  Pokedex-C
//
//  Created by Karl Pfister on 5/4/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

#import "DVMPokemon.h"

@implementation DVMPokemon

- (instancetype)initWithPokemonName:(NSString *)name identifier:(NSInteger)identifier abilities:(NSArray<NSString *> *)abilities spritePath:(NSString *)spritePath
{
    self = [super init];
    if (self)
    {
        _name = name;
        _identifier = identifier;
        _abilities = abilities;
        _spritePath = spritePath;
    }
    return self;
}

@end

@implementation DVMPokemon (JSONConvertable)

- (DVMPokemon *)initWithDictionary:(NSDictionary<NSString *,id> *)topLevelDictionary
{
    NSString *name = topLevelDictionary[@"name"];
    // let name = dictionary["name"] as? String
    NSInteger identifier = [topLevelDictionary[@"id"] integerValue];
    NSArray *abilitiesDict = topLevelDictionary[@"abilities"];
    NSString *spritePath = topLevelDictionary[@"sprites"][@"front_shiny"];

    if (![abilitiesDict isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray<NSString *> *abilities = [[NSMutableArray alloc] init];
    // let abilities : [String] = []
    for (NSDictionary *dictionary in abilitiesDict)
    {
        NSDictionary *abilityDict = dictionary[@"ability"];
        NSString *abilityName = abilityDict[@"name"];
        [abilities addObject:abilityName];
    }
    return [self initWithPokemonName:name identifier:identifier abilities:abilities spritePath:spritePath];
}

@end
