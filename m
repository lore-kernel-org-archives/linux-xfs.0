Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 22:28:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC6Ru8s015578
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 22:28:02 -0800
Date: Mon, 12 Nov 2007 17:27:54 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [[PATCH, RESEND]] Drop the ability to turn unwritten extents off completly
Message-ID: <20071112062754.GA66820511@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com> <1194839329-22003-1-git-send-email-xaiki@sgi.com> <1194839329-22003-2-git-send-email-xaiki@sgi.com> <1194839329-22003-3-git-send-email-xaiki@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194839329-22003-3-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xaiki@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2007 at 02:48:46PM +1100, xaiki@sgi.com wrote:
> From: Niv Sardi <xaiki@sgi.com>
> 

This needs a good description for why it's being removed and
the man pages need updating. (e.g. mkfs.xfs)

The code looks good, but NACK until the man page updates is done
as well.

Cheers,

dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
