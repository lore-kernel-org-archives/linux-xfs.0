Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LJK8Iv171084 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 14:20:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6341A15113AE
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 12:23:35 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ACTm1VtwuEosHOOa for <xfs@oss.sgi.com>;
	Thu, 21 Apr 2011 12:23:35 -0700 (PDT)
Message-ID: <4DB08437.302@sandeen.net>
Date: Thu, 21 Apr 2011 14:23:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] xfsprogs: fixes a regression hang in xfs_repair phase
 4
References: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
	<BANLkTi=2yrp5poJzeHD+u=2zY0nRgxX21g@mail.gmail.com>
In-Reply-To: <BANLkTi=2yrp5poJzeHD+u=2zY0nRgxX21g@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On 4/20/11 6:26 AM, Ajeet Yadav wrote:
> I guess the patch is not reviewed because of patch subject, but the
> problem is related to btree code.
> Can anyone please take out time to understand the problem

Do you happen to have an xfs_metadump of the corrupted filesystem which produced the hang?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
