"""
Random Joke Generator using JokeAPI
Fetches random jokes from an external API and displays them
"""

import requests
import json
from typing import Dict, Optional


class JokeGenerator:
    """A class to fetch and display random jokes from JokeAPI"""
    
    BASE_URL = "https://v2.jokeapi.dev/joke"
    
    def __init__(self):
        """Initialize the JokeGenerator with default settings"""
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'JokeGenerator/1.0'
        })
    
    def get_random_joke(self, 
                        category: str = "Any", 
                        joke_type: str = "any",
                        safe_mode: bool = False) -> Optional[Dict]:
        """
        Fetch a random joke from the API
        
        Args:
            category (str): Joke category - "Any", "General", "Knock-Knock", 
                          "Programming", "Dark", "Pun", "Spooky", "Christmas"
            joke_type (str): "any", "single", or "twopart"
            safe_mode (bool): If True, filters out offensive jokes
        
        Returns:
            Dict: Joke data or None if request fails
        """
        try:
            # Build the URL with parameters
            url = f"{self.BASE_URL}/{category}"
            params = {
                'type': joke_type,
                'safe-mode': str(safe_mode).lower()
            }
            
            response = self.session.get(url, params=params, timeout=5)
            response.raise_for_status()
            
            data = response.json()
            
            if data.get('error'):
                print(f"API Error: {data.get('message', 'Unknown error')}")
                return None
            
            return data
            
        except requests.exceptions.RequestException as e:
            print(f"Error fetching joke: {e}")
            return None
    
    def display_joke(self, joke_data: Dict) -> None:
        """
        Display the joke in a formatted way
        
        Args:
            joke_data (Dict): The joke data from the API
        """
        if not joke_data:
            return
        
        print("\n" + "="*60)
        
        if joke_data.get('type') == 'single':
            # Single-line joke
            print(f"Joke: {joke_data.get('joke', 'No joke data')}")
        
        elif joke_data.get('type') == 'twopart':
            # Two-part joke (setup and delivery)
            print(f"Setup: {joke_data.get('setup', '')}")
            print(f"Delivery: {joke_data.get('delivery', '')}")
        
        print("="*60 + "\n")
    
    def get_and_display_joke(self, **kwargs) -> Optional[Dict]:
        """
        Convenience method to fetch and display a joke in one call
        
        Args:
            **kwargs: Arguments to pass to get_random_joke()
        
        Returns:
            Dict: The joke data
        """
        joke_data = self.get_random_joke(**kwargs)
        self.display_joke(joke_data)
        return joke_data


def main():
    """Main function to demonstrate the joke generator"""
    
    print("🎭 Random Joke Generator 🎭")
    print("-" * 60)
    
    generator = JokeGenerator()
    
    # Example 1: Get a random joke from any category
    print("\n1. Random Joke from Any Category:")
    generator.get_and_display_joke()
    
    # Example 2: Get a programming joke
    print("2. Programming Joke:")
    generator.get_and_display_joke(category="Programming")
    
    # Example 3: Get a knock-knock joke
    print("3. Knock-Knock Joke:")
    generator.get_and_display_joke(category="Knock-Knock")
    
    # Example 4: Get a safe-mode joke
    print("4. Safe Mode Joke:")
    generator.get_and_display_joke(safe_mode=True)
    
    # Example 5: Get a single-line joke
    print("5. Single-Line Joke:")
    generator.get_and_display_joke(joke_type="single")


if __name__ == "__main__":
    main()
