Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VI5u7B058106 for <xfs@oss.sgi.com>; Thu, 31 May 2012 13:05:56 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id GdMrkkpWufnUI8co (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 May 2012 11:05:55 -0700 (PDT)
Date: Thu, 31 May 2012 20:05:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
In-Reply-To: <20120531175913.GH4721@sgi.com>
Message-ID: <alpine.LNX.2.01.1205312005390.14484@frira.zrqbmnf.qr>
References: <20120525103758.GD1707@infradead.org>
	<1337961147-11668-1-git-send-email-jengelh@inai.de>
	<1337961147-11668-2-git-send-email-jengelh@inai.de>
	<20120531175913.GH4721@sgi.com>
MIME-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: hch@infradead.org, joe@perches.com, xfs@oss.sgi.com

On Thursday 2012-05-31 19:59, Ben Myers wrote:

>Hey Jan,
>
>On Fri, May 25, 2012 at 05:52:26PM +0200, Jan Engelhardt wrote:
>> intptr_t and uintptr_t designate an (un)signed integer type capable of
>> holding void* pointers.
>> (http://pubs.opengroup.org/onlinepubs/000095399/basedefs/stdint.h.html )
>
>Would it be appropriate to CC linux-kernel on this one given the nature of the
>change?

Occurred now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
