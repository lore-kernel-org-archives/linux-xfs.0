Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E6D37CA7
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 07:52:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BF80AC001
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 05:52:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tQAwtPD5I6JjuVF5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 05:51:59 -0700 (PDT)
Date: Tue, 31 May 2016 05:51:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: Add BUILD_CFLAGS for cross compilation
Message-ID: <20160531125157.GB17018@infradead.org>
References: <1437913255-7524-4-git-send-email-tytso@mit.edu>
	<1454361909-36538-1-git-send-email-gwendal@chromium.org>
	<20160202180828.GA13880@infradead.org>
	<CAMHSBOUQ5eUL+Y+voDCwC9U7gmTsUZu2Oympn+c0=DxaU4egjA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMHSBOUQ5eUL+Y+voDCwC9U7gmTsUZu2Oympn+c0=DxaU4egjA@mail.gmail.com>
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
To: Gwendal Grignou <gwendal@chromium.org>
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 27, 2016 at 09:34:50AM -0700, Gwendal Grignou wrote:
> Looking at xfsprogs-4.5.0, that patch has not been applied. Did it not work?
> It still applies cleanly on 4.5.

It probably just got missed by Dave between all the patches on the list.
Can you just resend it with my Reviewed-by tag added?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
