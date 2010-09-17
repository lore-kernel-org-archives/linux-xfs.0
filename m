Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8HKI7Mp089454 for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 15:18:07 -0500
Received: from hermes2.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0C24E07DDC
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 13:30:59 -0700 (PDT)
Received: from hermes2.dur.ac.uk (hermes2.dur.ac.uk [129.234.248.2]) by
	cuda.sgi.com with ESMTP id 2VoF8Oa445mmUlES for
	<xfs@OSS.SGI.com>; Fri, 17 Sep 2010 13:30:59 -0700 (PDT)
Received: from mail.phyip3.dur.ac.uk (mail.phyip3.dur.ac.uk [129.234.186.130])
	by hermes2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id o8HKIOj5022695
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:18:33 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.phyip3.dur.ac.uk (Postfix) with ESMTP id D03FF8000B
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:18:24 +0100 (BST)
Received: from mail.phyip3.dur.ac.uk ([127.0.0.1])
	by localhost (mail.phyip3.dur.ac.uk [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 8aBxTaV5aQtM for <xfs@OSS.SGI.com>;
	Fri, 17 Sep 2010 21:18:22 +0100 (BST)
Received: from ty.sabi.co.UK (O1.PhyIP3.Dur.ac.UK [129.234.186.1])
	by mail.phyip3.dur.ac.uk (Postfix) with ESMTP id AEDAE8000C
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:18:22 +0100 (BST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1OwhL2-0003I4-QC
	for <xfs@OSS.SGI.com>; Fri, 17 Sep 2010 21:15:16 +0100
Message-ID: <19603.52303.867421.730126@tree.ty.sabi.co.uk>
Date: Fri, 17 Sep 2010 21:15:11 +0100
MIME-Version: 1.0
Subject: Re: System partially unusable after power loss...
In-Reply-To: <201009162323.54133@zmi.at>
References: <i6ttq6$41d$1@dough.gmane.org> <201009162323.54133@zmi.at>
From: pg@xfs2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>


> I've had the same issues, that's why I now run my KDE directory on an 
> ext4 partition again. I really love XFS, but KDE it seems doesn't sync 
> enough, or always changes some files, as I've had crashes at a time 
> where nobody worked still some KDE config files were 0 afterwards. 

Why would anyone still be caught out by the 'O_PONIES' issue?

It is very well documented, and even minimally aware people
should have read at least the XFS FAQ, and/or:

http://sandeen.net/wordpress/?p=42
http://sandeen.net/wordpress/?p=34
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
