const path = require("path");

const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const {CleanWebpackPlugin} = require("clean-webpack-plugin");

const ESLintPlugin = require("eslint-webpack-plugin");
const StylelintPlugin = require("stylelint-webpack-plugin");

const isDevelopment = process.env.NODE_ENV === "development";

const styleUse = isDevelopment ?
    ["style-loader", "css-loader"] :
    [MiniCssExtractPlugin.loader, "css-loader"];

module.exports = {
    entry: ["./src/index.coffee", "./src/index.scss"],
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "[name].[chunkhash:6].js",
    },
    module: {
        rules: [
            {
                test: /\.coffee$/,
                loader: "coffee-loader"
            },
            {
                test: /\.s[ac]ss$/i,
                use: [
                    ...styleUse,
                    {
                        loader: "postcss-loader",
                        options: {
                            postcssOptions: {
                                plugins: [require("autoprefixer")]
                            }
                        }
                    },
                    "sass-loader",
                ],
            },
        ],
    },
    plugins: [
        new CleanWebpackPlugin(),
        new ESLintPlugin({
            extensions: ["coffee"]
        }),
        new StylelintPlugin({
            extensions: ["scss"]
        }),
        new MiniCssExtractPlugin({
            filename: "[name].[chunkhash:6].css",
        }),
        new HtmlWebpackPlugin({
            template: path.resolve(__dirname, "./src/index.html")
        }),
    ]
}