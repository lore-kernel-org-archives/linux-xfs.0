Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEKPOhU238157 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 14:25:24 -0600
Date: Mon, 14 Nov 2011 15:25:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: add .ltdep to .gitignore
Message-ID: <20111114202522.GA4349@infradead.org>
References: <1321289730-12687-1-git-send-email-bpm@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321289730-12687-1-git-send-email-bpm@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 14, 2011 at 10:55:30AM -0600, Ben Myers wrote:
> Make git ignore all .ltdep files.  They are created as part of the build
> process:
> 
> 	inventory/.ltdep
> 	librmt/.ltdep
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Looks good, I'll apply it with the next round of xfsdump updates.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
