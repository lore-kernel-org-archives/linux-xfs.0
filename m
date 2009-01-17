Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HNoER9018688 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 17:50:14 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C924181278C
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 15:50:12 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 1VBAf9Fd50qXcnVe for
	<xfs@oss.sgi.com>; Sat, 17 Jan 2009 15:50:12 -0800 (PST)
Message-ID: <49726E94.4060806@sandeen.net>
Date: Sat, 17 Jan 2009 17:49:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: help with xfs_repair on 10TB fs
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>	<4972166D.5000006@sandeen.net>	<adcf4ef70901171042p31054ae0rb56819fce7b6f47e@mail.gmail.com>	<49722875.90202@sandeen.net>
	<adcf4ef70901171514v2fa036a6o9deb0df7d9dd569d@mail.gmail.com>
In-Reply-To: <adcf4ef70901171514v2fa036a6o9deb0df7d9dd569d@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Alberto Accomazzi <aaccomazzi@gmail.com>
Cc: xfs@oss.sgi.com

Alberto Accomazzi wrote:


> For the record, after upgrading to xfsprogs-2.10.2 as suggested by
> Eric, xfs_repair completed successfully.  Unfortunately now I'm left
> with dealing with quite a mess: 388K files in lost+found, with a
> filesystem of over 160M inodes.  ugh...
> 
> Thanks for all your help, though...
> -- Alberto

Bummer.  What was the first thing that went wrong, by the way?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
