Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 10:17:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1SIHKMQ001341
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 10:17:23 -0800
Date: Fri, 29 Feb 2008 05:17:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC, patch 1/2] Allow up to 1GB logs in mkfs.xfs
Message-ID: <20080228181743.GX155259@sgi.com>
References: <20080221230833.GG155407@sgi.com> <ncctzk11zhl.fsf@sgi.com> <20080222050301.GP155407@sgi.com> <47BE6122.5040007@sgi.com> <20080222065338.GQ155407@sgi.com> <47C21585.8030504@sgi.com> <47C21A67.1010706@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C21A67.1010706@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: markgw@sgi.com, David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 25, 2008 at 12:31:19PM +1100, Lachlan McIlroy wrote:
> Does a larger on-disk log mean we can have a lot more items in the AIL?

Yes.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
