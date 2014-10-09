Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17D017F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 23:40:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7717304064
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 21:40:27 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id YlMltaFSJtE9mUAH
	for <xfs@oss.sgi.com>; Wed, 08 Oct 2014 21:40:26 -0700 (PDT)
Received: from [192.168.100.53] (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221])
	by greer.hardwarefreak.com (Postfix) with ESMTPA id 38A776C0DC
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 23:40:26 -0500 (CDT)
Message-ID: <543611CF.6030904@hardwarefreak.com>
Date: Wed, 08 Oct 2014 23:40:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: gather write metrics on multiple files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Does anyone know of a utility that can track writes to files in an XFS directory tree, or filesystem wide for that matter, and gather filesystem blocks written per second data, or simply KiB/s, etc?  I need to analyze an application's actual IO behavior to see if it matches what I'm being told the application is supposed to be doing.

Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
