Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CKmYsq019800 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 14:48:34 -0600
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id X9UiylGSSAEly0SK for
	<xfs@oss.sgi.com>; Thu, 12 Jan 2012 12:48:32 -0800 (PST)
Date: Thu, 12 Jan 2012 15:48:26 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Message-ID: <20120112204826.GG6626@thunk.org>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> reproduce deadlocks due to dirty data as well so please test these patches out.
> Thanks. Also review of patches is welcome.

This patch series looks good to me (modulo issues others have already
pointed out).

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

I assume you're going to send this up through Al's vfs tree?

  	 	      	      	      	      - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
