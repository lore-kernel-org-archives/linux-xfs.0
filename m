Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3011D7F50
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 01:53:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC07BAC00A
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 23:53:02 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ECIHQkBF7PNAZ1j6 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 23:52:59 -0700 (PDT)
Date: Wed, 12 Aug 2015 23:52:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: Introduce writeback context for writepages
Message-ID: <20150813065258.GA677@infradead.org>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
	<1439333388-16452-2-git-send-email-david@fromorbit.com>
	<20150812072635.GA32399@infradead.org>
	<20150813013244.GP3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813013244.GP3902@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Aug 13, 2015 at 11:32:44AM +1000, Dave Chinner wrote:
> > http://thread.gmane.org/gmane.comp.file-systems.xfs.general/39030/focus=39009
> 
> I completely forgot you did this. I'll go back and look at it
> and see what I can pull from it. Thanks for the reminder, Christoph.

As far as I can tell your new version is superior in all aspects
except for the patch split :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
