Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:33616 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeJRVhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 17:37:51 -0400
Received: by mail-wr1-f45.google.com with SMTP id e4-v6so33736863wrs.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 06:36:45 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
From: Avi Kivity <avi@scylladb.com>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
Message-ID: <85530ca3-22ef-21e5-a4da-1f924a6e2d7e@scylladb.com>
Date: Thu, 18 Oct 2018 16:36:42 +0300
MIME-Version: 1.0
In-Reply-To: <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 18/10/2018 14.00, Avi Kivity wrote:
>
>> Can I get access to the metadump to dig around in the filesystem
>> directly so I can see how everything has ended up laid out? that
>> will help me work out what is actually occurring and determine if
>> mkfs/mount options can address the problem or whether deeper
>> allocator algorithm changes may be necessary....
>
>
> I will ask permission to share the dump.
>
>
>

I'll send you a link privately.
