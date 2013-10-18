Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F36A97F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:40:27 -0500 (CDT)
Message-ID: <52616477.3000207@sgi.com>
Date: Fri, 18 Oct 2013 11:40:23 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
References: <1379829679.4089.2.camel@ThinkPad-T5421>	<5241E125.7010902@sgi.com>
	<1380094327.2526.5.camel@ThinkPad-T5421>	<5242F31B.4060902@sandeen.net>
	<1380177932.2983.11.camel@ThinkPad-T5421>
In-Reply-To: <1380177932.2983.11.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, xfsprogs <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit 548c2e3e5b123266b4b89cc81bedd113442570b8
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Thu Sep 26 06:45:32 2013 +0000

     [v3, 1/2] xfsprogs: fix potential memory leak in 
verify_set_primary_sb()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
