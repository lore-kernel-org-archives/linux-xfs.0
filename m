Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o67Kx1jm256439 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 15:59:02 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0CC2B8F5A3
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 14:07:25 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id uhaOMq84ABHQxX5C for
	<xfs@oss.sgi.com>; Wed, 07 Jul 2010 14:07:25 -0700 (PDT)
Message-ID: <4C34EB2A.5060701@tlinx.org>
Date: Wed, 07 Jul 2010 14:01:30 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt;
	though	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
References: <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org>	<20100629232532.GA24712@dastard>	<4C2A87FF.7090804@dermichi.com>
	<4C2A92DA.1020202@tlinx.org>	<20100630011647.GD24712@dastard>
	<4C2AAFC1.9080708@tlinx.org>	<20100701235802.GW24712@dastard>
	<4C33F20F.4040905@tlinx.org>	<4C341712.5030202@tlinx.org>
	<20100707063634.GI25018@dastard> <4C34492E.1080109@tlinx.org>
In-Reply-To: <4C34492E.1080109@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>

> Dave Chinner wrote:
>> Can you send me a link to a metadump image of the filesystem so I can
>> look at the broken directories in detail?
-----
Don't have link - not sure where I'd put it up for download,
Would there be a place you'd want an upload, or I it's small 
enough to email, but maybe not to the list.

with the deletions, and compressed with unix util 7z, it's 2.7M.

xfs_dump options were 'xfs_metadump -o -w -g /dev/Home/Home metadump.out









_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
