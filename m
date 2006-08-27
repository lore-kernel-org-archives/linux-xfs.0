Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 13:43:17 -0700 (PDT)
Received: from smtp108.sbc.mail.mud.yahoo.com (smtp108.sbc.mail.mud.yahoo.com [68.142.198.207])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7RKh1DW028222
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 13:43:05 -0700
Date: Sun, 27 Aug 2006 13:42:22 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
Message-ID: <20060827204222.GB12065@tuatara.stupidest.org>
References: <20060827072810.GA4098@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060827072810.GA4098@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Cc: xfs@oss.sgi.com

On Sun, Aug 27, 2006 at 09:28:10AM +0200, Louis-David Mitterrand wrote:

> 	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory

Not enough memory, try adding swap space if that's possible?  (BTW,
how much memory do you have in this case?)
