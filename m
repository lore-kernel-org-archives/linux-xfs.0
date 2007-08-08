Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 22:00:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78507bm032147
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 22:00:10 -0700
Message-ID: <46B94DDC.7040100@sandeen.net>
Date: Wed, 08 Aug 2007 00:00:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: qa 166 failure on f8 kernel
References: <46B91EBA.10407@sandeen.net> <20070808025615.GH52011508@sgi.com> <46B9316A.40508@sandeen.net> <20070808040804.GJ52011508@sgi.com> <46B94259.6060309@sandeen.net> <20070808041920.GK52011508@sgi.com> <46B94680.3070405@sandeen.net> <op.twp5etpa3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.twp5etpa3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:

> Instead of "no flags", how about "00000" so the test doesn't break
> with xfsprogs 2.9.x and later.
> 
> 
[root@inode xfstests]# rpm -q xfsprogs
xfsprogs-2.9.3-1


I have that... but... whatever works :)

-Eric
