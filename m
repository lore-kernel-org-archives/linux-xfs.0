Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7J7oPOa196189 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 02:50:36 -0500
Received: from mail-bw0-f210.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9AA71D5C541
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 00:50:44 -0700 (PDT)
Received: from mail-bw0-f210.google.com (mail-bw0-f210.google.com
	[209.85.218.210]) by cuda.sgi.com with ESMTP id
	k4iaLRMAXHALXIdg for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2009 00:50:44 -0700 (PDT)
Received: by bwz6 with SMTP id 6so3944774bwz.20
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 00:50:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090814141807.GA2891@infradead.org>
References: <200908110921.50752.Christian.Fischer@easterngraphics.com>
	<20090811142029.GB30913@infradead.org>
	<200908141456.58683.Christian.Fischer@easterngraphics.com>
	<20090814141807.GA2891@infradead.org>
Date: Wed, 19 Aug 2009 08:50:39 +0100
Message-ID: <f4527be0908190050h5f3a4ca8h7d1712ab677616db@mail.gmail.com>
Subject: Re: [Patch] Re: xfs crash, kernel 2.6.29
From: Andrew Lyon <andrew.lyon@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christian Fischer <Christian.Fischer@easterngraphics.com>, xfs@oss.sgi.com

On Fri, Aug 14, 2009 at 3:18 PM, Christoph Hellwig<hch@infradead.org> wrote:
> On Fri, Aug 14, 2009 at 02:56:58PM +0200, Christian Fischer wrote:
>> backported to 2.6.29-xen-r4 from
>> http://code.google.com/p/gentoo-xen-kernel/downloads/list
>>
>> Can you please review it?
>
> I'll reviewed it and do some QA over the weekend, and we'll send it to
> -stable then.
>
>

Did the patch fix the problem?

Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
