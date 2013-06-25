Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 305C27F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 12:49:56 -0500 (CDT)
Date: Tue, 25 Jun 2013 12:49:52 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfstests generic/313: test ctime and mtime are
	updated on truncate and ftruncate
Message-ID: <20130625174952.GB20932@sgi.com>
References: <1370406102-28041-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370406102-28041-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 05, 2013 at 12:21:42PM +0800, Eryu Guan wrote:
> Regression test for commit:
> 3972f26 btrfs: update timestamps on truncate()
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
