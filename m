Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 01:43:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4E8gvN1002356
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 01:43:00 -0700
Date: Wed, 14 May 2008 04:43:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] XFS: ASCII case-insensitivity support
Message-ID: <20080514084344.GA4333@infradead.org>
References: <20080514075244.738514733@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514075244.738514733@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

All patches looks good to me, but please add a comment describing the
conditional d_reash in the create case.
