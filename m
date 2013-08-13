Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBE8D29E14
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 17:31:18 -0500 (CDT)
Message-ID: <520AB3B4.7000808@sgi.com>
Date: Tue, 13 Aug 2013 17:31:16 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xftests: renumber existing btrfs tests to start with
 1
References: <1375793841-25114-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1375793841-25114-1-git-send-email-dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On 08/06/2013 07:57 AM, David Sterba wrote:
> Current numbering is inheried from the single testsuite series. There
> are only 6 btrfs-specific tests and it makes more sense to start adding
> new ones at a more natural place than 300-something. There's no overlap
> with the old and new numbers and I hope there' will be no confusion when
> referencing them.
>
> Signed-off-by: David Sterba <dsterba@suse.cz>

Thanks David, this has been committed.

--Rich

commit aab6d4e47d51b5cf4e5fc4a15a5dee80fb72aab4
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 13 16:16:27 2013 -0500

     xfstests: renumber existing btrfs tests to start with 1

     Current numbering is inheried from the single testsuite series. There
     are only 6 btrfs-specific tests and it makes more sense to start adding
     new ones at a more natural place than 300-something. There's no overlap
     with the old and new numbers and I hope there' will be no confusion 
when
     referencing them.

     Signed-off-by: David Sterba <dsterba@suse.cz>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
