Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LFW70C085500 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 10:32:07 -0500
Date: Thu, 21 Jun 2012 10:32:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2 v2] xfs: rename log structure and remove xlog_t
	typedef.
Message-ID: <20120621153232.GB2503@sgi.com>
References: <20120614142214.445982138@sgi.com>
	<20120614142430.963813265@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120614142430.963813265@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

Mark,

On Thu, Jun 14, 2012 at 09:22:15AM -0500, tinguely@sgi.com wrote:
> From: Mark Tinguely <tinguely@sgi.com>
> 
> Rename the XFS log structure to xlog to help crash distinquish it from the
> other logs in Linux.

This is another patch that I'm planning on adding to a 3.5-rc pull request.
Being able to use crash on 3.5 dumps is essential for supportability.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
