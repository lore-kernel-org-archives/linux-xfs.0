Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n43EUeO5105876 for <xfs@oss.sgi.com>; Sun, 3 May 2009 09:30:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 902D0146C18E
	for <xfs@oss.sgi.com>; Sun,  3 May 2009 07:34:28 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 2VNCSFkmbcnKCBjd for
	<xfs@oss.sgi.com>; Sun, 03 May 2009 07:34:28 -0700 (PDT)
Message-ID: <49FDAA8E.80205@sandeen.net>
Date: Sun, 03 May 2009 09:30:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>	
	<20090502101405.GA6145@fancy-poultry.org>	
	<a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>	
	<49FC9762.6010109@sandeen.net>	
	<a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>	
	<49FD2488.70503@sandeen.net>
	<a4423d670905030015h59038741of55bae686ef923f0@mail.gmail.com>
In-Reply-To: <a4423d670905030015h59038741of55bae686ef923f0@mail.gmail.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs@oss.sgi.com

Alexander Beregalov wrote:
> 2009/5/3 Eric Sandeen <sandeen@sandeen.net>:
...

>> Does this happen if you try to defrag a single file?  i.e. something like:
> Yes, it does.

Oh, interesting.  I didn't really expect that.  The testcase I provided
worked for me.  Maybe you can provide your kernel .config and I'll try
on a 32-bit box (I only tested 64-bit so far).

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
