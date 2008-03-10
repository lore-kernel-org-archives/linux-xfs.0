Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 23:10:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2A6AFBL012856
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 23:10:18 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4280AF4EB94
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2008 23:10:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id jK0BQTQEGrQsSDES for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 23:10:46 -0700 (PDT)
Date: Mon, 10 Mar 2008 02:10:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: assfail during unmount xfs 2.6.24.3 [from 2.6.24.y git]
Message-ID: <20080310061013.GA3496@infradead.org>
References: <200803062329.10486.Chris.Knadle@coredump.us> <20080307224645.GW155259@sgi.com> <200803081555.11695.Chris.Knadle@coredump.us> <20080309221858.GS155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309221858.GS155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Chris Knadle <Chris.Knadle@coredump.us>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On Mon, Mar 10, 2008 at 09:18:58AM +1100, David Chinner wrote:
> Only if the per-vfsmount writer counts got merged in 2.6.25-rcX. I'm not sure
> that they did. Christoph?

No, it didn't go in.  The new target is 2.6.26.
