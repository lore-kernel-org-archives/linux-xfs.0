Return-Path: <xfs-bounces@oss.sgi.com>
Date: Thu, 22 Mar 2012 13:33:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] fs: xfs: fix section mismatch in linux-next
Message-ID: <20120322183334.GN8451@sgi.com>
References: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
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
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: xfs@oss.sgi.com, elder@kernel.org, linux-kernel@vger.kernel.org, xfs-master@oss.sgi.com

On Fri, Mar 16, 2012 at 11:36:18AM -0700, Gerard Snitselaar wrote:
> xfs_qm_exit() is called in init_xfs_fs().
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Thanks Gerard.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
