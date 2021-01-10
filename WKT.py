from osgeo import ogr
wkt = "LINESTRING (599014.56614022 122720.3365975 0, 599006.884341362 122730.553142569 0, 599043.436147199 122757.459124949 0, 599043.879713729 122758.981477779 0, 599049.101277935 122762.320059118 0, 599050.923678081 122762.270618242 0, 599062.450721378 122770.86291496 0, 599060.232863768 122762.956491514 0, 599038.991232115 122691.798449488 0, 599153.010398828 122654.945109786 0, 599142.708219781 122607.308265456 0, 599130.090810323 122559.573192933 0, 599117.91649412 122511.849943134 0, 599105.741905024 122463.757960791 0, 599104.016937378 122458.073381647 0, 599102.636729763 122452.18000586 0, 599100.86238632 122445.844670219 0, 599099.334297183 122439.349666457 0, 599095.834849872 122426.691231363 0, 599092.335467495 122414.499350776 0, 599079.125606811 122364.012446819 0, 599077.105282246 122359.739861822 0, 599075.626895683 122356.05655043 0, 599074.59162909 122351.243528597 0, 599071.093495568 122346.627396505 0, 599070.846944258 122345.154008229 0, 599074.196107003 122342.992380838 0, 599082.962986688 122336.998874897 0, 599089.563022959 122333.854395083 0, 599090.252730438 122334.394534694 0, 599092.173881805 122334.885346067 0, 599093.257381289 122333.853753579 0, 599093.306196798 122331.299790168 0, 599101.728283076 122325.159017389 0, 599103.353483244 122323.292383903 0, 599104.584315915 122319.657691348 0, 599109.657521145 122317.348436573 0, 599110.987134861 122315.23627977 0, 599110.10014301 122313.222728851 0, 599108.967076647 122312.486201454 0, 599104.829387747 122312.536023097 0, 599100.839397823 122312.143790106 0, 599098.179136062 122310.327003993 0, 599092.46414008 122304.385108616 0, 599088.276262828 122299.130553985 0, 599087.437782094 122292.893115256 0, 599085.614557847 122289.111587281 0, 599083.791511627 122286.361470828 0, 599087.881228211 122293.580646081 0, 599088.67033874 122299.179600137 0, 599097.883433656 122309.442990004 0, 599100.494496765 122311.603587697 0, 599103.84430591 122313.027338747 0, 599109.361134686 122312.43701962 0, 599110.937951777 122315.678320151 0, 599109.903870988 122317.69219721 0, 599103.008229256 122320.689368658 0, 599102.467139043 122325.06066133 0, 599093.650901634 122330.710356066 0, 599092.76489386 122334.394098518 0, 599091.287244497 122334.93461445 0, 599089.612289612 122333.903501061 0, 599070.896202265 122345.153999491 0, 599071.093565237 122347.020311652 0, 599074.739446343 122351.489074264 0, 599077.105394766 122360.378347423 0, 599078.829722796 122362.0970431 0, 599116.930815645 122508.608654888 0, 599153.355201563 122655.043277126 0, 599124.739348685 122663.691647973 0, 599095.778918382 122673.027774245 0, 599067.114098334 122682.265760836 0, 599038.941932221 122691.552901746 0, 599062.844816632 122771.206619064 0, 599051.022204444 122762.368821888 0, 599049.101251223 122762.172726943 0, 599043.928985952 122759.079690265 0, 599043.140549498 122757.066292661 0, 599006.933623775 122730.700466277 0, 599014.615358048 122720.140143897 0)"
geom = ogr.CreateGeometryFromWkt(wkt)
print "Length = %2f" % geom.Length()
