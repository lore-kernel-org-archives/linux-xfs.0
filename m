Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8CLMPG031234 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:21:22 -0600
Date: Sat, 8 Dec 2012 07:23:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/5] xfs: rename bli_format to avoid confusion with
	bli_formats
Message-ID: <20121208122348.GB29107@infradead.org>
References: <20121204231801.982422341@sgi.com>
	<20121204224938.703805260@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121204224938.703805260@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 04, 2012 at 05:18:03PM -0600, Mark Tinguely wrote:
> Rename the bli_format structure to __bli_format to avoid
> accidently confusing them with the bli_formats pointer.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
