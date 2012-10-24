Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OM8k6P058359 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 17:08:46 -0500
Date: Wed, 24 Oct 2012 17:10:31 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v6] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20121024221030.GU1377@sgi.com>
References: <143becf0f8266fbc8025ec97c8f44476d8fcafc5.1348203015.git.rprabhu@wnohang.net>
	<20120925094013.GI9189@infradead.org>
	<CAEtq3tNGSatvn2XGXg=O+OQGPPMVGhDcFN9szBoSZtRQ8XggmA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEtq3tNGSatvn2XGXg=O+OQGPPMVGhDcFN9szBoSZtRQ8XggmA@mail.gmail.com>
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
To: Raghavendra Prabhu <raghu.prabhu13@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

Hi Raghavendra,

On Thu, Oct 25, 2012 at 02:27:31AM +0530, Raghavendra Prabhu wrote:
> Thank you. Are there any comments on this patch or has is it been acked?

This patch no longer applies cleanly on the master brach.  Could you resolve
the conflicts and repost?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
