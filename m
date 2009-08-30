Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7U1LcNU253652 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 20:21:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CDFC1583BFB
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 18:22:03 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id O5ja6fCwkimJoDco for
	<xfs@oss.sgi.com>; Sat, 29 Aug 2009 18:22:03 -0700 (PDT)
Message-ID: <4A99D43D.5050208@sandeen.net>
Date: Sat, 29 Aug 2009 18:22:05 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: pushing out a new xfsprogs release,	was Re: [PATCH] xfsprogs:
	fix unaligned access in libxfs
References: <20090828153718.GA26409@infradead.org>	<4A9810C7.8010806@sandeen.net>	<20090828182454.GA8217@infradead.org>
	<200908300017.07268@zmi.at>
In-Reply-To: <200908300017.07268@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Freitag 28 August 2009 Christoph Hellwig wrote:
>> What do people thing about pushing out a 3.0.3 xfsprogs
>> release?
> 
> Is there the patch to repair my filesystem? I sent the metadump to Eric 
> once, I think he did some patches. Are they there, or do I need 
> something else also? I'm still having the problem, and would like to fix 
> it.
> 
> mfg zmi

Afraid I haven't fixed that one yet, sorry.  If you could open a bug on 
xfs.org's bugzilla it'd be much better for tracking ...

I did find that building xfsprogs w/o debug ASSERTs turned on, I could 
get a clean fs after 2 runs, just to get you going again...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
