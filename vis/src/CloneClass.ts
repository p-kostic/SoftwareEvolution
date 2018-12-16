export interface CloneClass {
    locations: Location[];
}

export interface Location {
    path: string;
    startLocation: [number, number];
    endLocation: [number, number];
}