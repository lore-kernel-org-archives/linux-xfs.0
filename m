Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 596027CA4
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 09:19:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C86AAAC001
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:19:35 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id NVs56hES6jbjrU5h (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 07:19:31 -0700 (PDT)
Subject: Re: Internal error xfs_trans_cancel
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
	<e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
	<0644b434-6cea-4188-9702-469c26d191b8@monom.org>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <13fe17d7-3a51-f7f9-0c03-67151d27f6b9@monom.org>
Date: Wed, 1 Jun 2016 16:19:29 +0200
MIME-Version: 1.0
In-Reply-To: <0644b434-6cea-4188-9702-469c26d191b8@monom.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

>   via my test script:

Looks like my email client did not agree with my formatting of the script.

https://www.monom.org/data/lglock/run-tests.sh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
