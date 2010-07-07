Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o671mSHU212091 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 20:48:28 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7488A42E985
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 18:51:18 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id rvAoslEZeXVwiJHF for
	<xfs@oss.sgi.com>; Tue, 06 Jul 2010 18:51:18 -0700 (PDT)
References: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
	<20100706231856.GC25018@dastard>
In-Reply-To: <20100706231856.GC25018@dastard>
Mime-Version: 1.0 (iPhone Mail 8A293)
Message-Id: <5AFCEF9B-5A38-496F-BF40-5B535FE58ACA@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: CentOS 5.5 XFS internal errors (XFS_WANT_CORRUPTED_GOTO)
Date: Tue, 6 Jul 2010 20:51:16 -0500
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
To: Dave Chinner <david@fromorbit.com>
Cc: Shaun Adolphson <shaun@adolphson.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Jul 6, 2010, at 6:18 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jul 06, 2010 at 08:57:45PM +1000, Shaun Adolphson wrote:
>> .
>> 
>> Some further details about the system:
>> 
>> Software:
>> - Fresh install of CentOS 5.5 64bit all patches up to date
>> - Kernel 2.6.18-194.3.1.el5.centos.plus
> 
> I've got no idea exactly what version of XFS that has in it, so I
> can't say off the top of my head whether this is a fixed bug or not.
> 
Assuming it's what is in the real RHEL it's 2.6.28.6 and a few patches IIRC, rpm changelog should say.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
