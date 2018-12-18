const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
    mode: "development",
    devtool: "inline-source-map",
    entry: "./src/index.ts",
    output: {
        path: path.join(__dirname, "dist"),
        publicPath: "/",
        filename: "index.[hash:8].js"
    },
    resolve: {
        extensions: [".js", ".ts"]
    },
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: [
                    { loader: "ts-loader" }
                ]
            }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            title: "Clone Visualisation",
            filename: "index.html",
            template: './src/index.html',
        })
    ]
};
