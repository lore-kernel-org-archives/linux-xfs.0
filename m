Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 391317F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 14:34:01 -0500 (CDT)
Message-ID: <52618D22.9000809@sgi.com>
Date: Fri, 18 Oct 2013 14:33:54 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs: fix resource leak in longform_dir2_rebuild()
References: <1381560174.3064.4.camel@ThinkPad-T5421>	<20131014214601.GJ5663@dastard>
	<1381805731.3106.5.camel@ThinkPad-T5421>
In-Reply-To: <1381805731.3106.5.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit 14e36e34ed975b1ffbbcbc18a7743a3a4859be3d
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Tue Oct 15 02:55:31 2013 +0000

     xfsprogs: fix resource leak in longform_dir2_rebuild()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
