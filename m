Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08DD97F6F
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 09:10:06 -0500 (CDT)
Message-ID: <52122768.6000203@sgi.com>
Date: Mon, 19 Aug 2013 09:10:48 -0500
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

Looks good.

Reviewed-by: <rjohnston@sgi.com>

On 06/27/2013 11:03 AM, Dwight Engen wrote:
> Add new program nsexec to facilitate creating/entering a user namespace. The
> orignal source for the program is https://lwn.net/Articles/539940. I added
   original

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
