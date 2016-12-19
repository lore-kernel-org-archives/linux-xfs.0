Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:27295 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751583AbcLSV1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 16:27:09 -0500
Date: Tue, 20 Dec 2016 08:26:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Switching from group to project quota's
Message-ID: <20161219212636.GO4326@dastard>
References: <8f374ce3da8517c472b897b07ec28517@ncoulson.com>
 <d69ca26d-4c6c-e5a6-1c36-9d28f0b53a5a@sandeen.net>
 <d684dc35-cc2a-b582-18d7-d9a7c30cd38c@ncoulson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d684dc35-cc2a-b582-18d7-d9a7c30cd38c@ncoulson.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Coulson <ncoulson-ml@ncoulson.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Mon, Dec 19, 2016 at 11:23:19AM -0800, Nathan Coulson wrote:
> With the long quotacheck time (+1wk,  I think one test I left
> running for a few weeks) with our filesystem (not sure if that is
> due to the number of files we have, or if something else is at
> play),  I was hoping to find an alternative.

It's hung. output of sysrq-w please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
