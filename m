Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 245187F50
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 11:15:53 -0500 (CDT)
Date: Tue, 9 Jul 2013 11:15:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfstest: ensure small symlink is removed
Message-ID: <20130709161549.GQ20932@sgi.com>
References: <20130617203513.700537361@sgi.com> <20130708221543.GN20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130708221543.GN20932@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 08, 2013 at 05:15:43PM -0500, Ben Myers wrote:
> On Mon, Jun 17, 2013 at 08:35:05PM -0500, Mark Tinguely wrote:
> > Tests the XFS symlinks that are small enough to be in the
> > inode, but were move to a remote symlink due to an extended
> > attribute were correctly removed.
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> 
> Works great. 
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
