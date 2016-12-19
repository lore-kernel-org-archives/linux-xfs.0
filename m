Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.bravenet.com ([65.39.176.20]:53376 "EHLO mail.bravenet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752043AbcLSXxA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Dec 2016 18:53:00 -0500
Reply-To: ncoulson-ml@ncoulson.com
Subject: Re: Switching from group to project quota's
References: <8f374ce3da8517c472b897b07ec28517@ncoulson.com>
 <d69ca26d-4c6c-e5a6-1c36-9d28f0b53a5a@sandeen.net>
 <d684dc35-cc2a-b582-18d7-d9a7c30cd38c@ncoulson.com>
 <20161219212636.GO4326@dastard>
From: Nathan Coulson <ncoulson-ml@ncoulson.com>
Message-ID: <09e1f03d-3c33-7aa5-9e14-22038811d63a@ncoulson.com>
Date: Mon, 19 Dec 2016 15:52:58 -0800
MIME-Version: 1.0
In-Reply-To: <20161219212636.GO4326@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On 2016-12-19 01:26 PM, Dave Chinner wrote:
> On Mon, Dec 19, 2016 at 11:23:19AM -0800, Nathan Coulson wrote:
>> With the long quotacheck time (+1wk,  I think one test I left
>> running for a few weeks) with our filesystem (not sure if that is
>> due to the number of files we have, or if something else is at
>> play),  I was hoping to find an alternative.
> It's hung. output of sysrq-w please.
>
> Cheers,
>
> Dave.

I will need to setup the test again,  (machine has since been 
rebooted).  I should be able to get resetup again tomorrow.

