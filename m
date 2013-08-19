Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A85F7F83
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 10:02:47 -0500 (CDT)
Message-ID: <521233C1.1050908@sgi.com>
Date: Mon, 19 Aug 2013 10:03:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfstests: add nsexec user namespace helper
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
	<20130627120328.2ed716ef@oracle.com>
In-Reply-To: <20130627120328.2ed716ef@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

Thanks for the patch Dwight, it has been committed.

--Rich

commit 3f424be6396205edd6aec1d46de04349aebe9306
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Jun 27 16:03:28 2013 +0000

     xfstests: add nsexec user namespace helper

     Add new program nsexec to facilitate creating/entering a user 
namespace. The
     original source for the program is https://lwn.net/Articles/539940. 
I added
     the -s option to become "root" in the user namespace.

     Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
     Reviewed-by: <rjohnston@sgi.com>
     Signed-off-by: <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
