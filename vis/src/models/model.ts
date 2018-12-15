export interface CloneClass {
    locations: Location[];
}

export interface Location {
    file: string;
    startLocation: [number, number];
    endLocation: [number, number];
}

