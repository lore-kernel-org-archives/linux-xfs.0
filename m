Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QLNXFY257206 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 16:23:34 -0500
Date: Wed, 26 Sep 2012 16:24:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V4] Make inode64 a remountable option
Message-ID: <20120926212444.GE13214@sgi.com>
References: <1345238378-10123-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1345238378-10123-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 17, 2012 at 06:19:38PM -0300, Carlos Maiolino wrote:
> Actually, there is no reason about why a user must umount and mount a XFS
> filesystem to enable 'inode64' option. So, this patch makes this a remountable
> option.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

committed to git://oss.sgi.com/xfs/xfs.git, master and for-next branches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
