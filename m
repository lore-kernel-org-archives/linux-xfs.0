Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42778 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752694AbeC1UMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 16:12:40 -0400
Subject: Re: [PATCH] xfs_scrub: fix build with older kernel headers
References: <7ea1df02d0f2549b6249c8bee1f6ae02bf1251a9.1521925697.git.baruch@tkos.co.il>
 <20180326180946.GT4818@magnolia>
 <f48bedc9-b532-3e1f-f434-2409a5d93469@sandeen.net>
 <20180328200752.p7ckzne2lugh7jir@tarshish>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dcc7f9db-21c0-d8dd-eab7-b3626b440f8d@sandeen.net>
Date: Wed, 28 Mar 2018 15:12:39 -0500
MIME-Version: 1.0
In-Reply-To: <20180328200752.p7ckzne2lugh7jir@tarshish>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 3/28/18 3:07 PM, Baruch Siach wrote:
> Hi Eric,
> 

...

> Yes. I verified that commit a440f8773794 (slightly modified to apply to 
> v4.15.1) fixes build with the affected toolchain.

Thank you!

-Eric
