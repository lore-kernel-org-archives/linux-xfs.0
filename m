Return-Path: <xfs-bounces@oss.sgi.com>
Date: Wed, 18 Jan 2012 16:36:02 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/1] xfs: kill the unused XFS_BB_FSB_OFFSET macro
Message-ID: <20120118223602.GA30741@sgi.com>
References: <1326716676-11842-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326716676-11842-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Alex Elder <elder@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 05:54:36PM +0530, Amit Sahrawat wrote:
> Removing the macro, as this is no more needed in the code.
> Tried to find the reference when it was last used - but the usage
> for this seemed to have been dropped long time ago.
> 
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
