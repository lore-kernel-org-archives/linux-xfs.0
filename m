Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25339 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752827AbdICDSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 23:18:04 -0400
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
 <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
Date: Sat, 2 Sep 2017 20:18:01 -0700
MIME-Version: 1.0
In-Reply-To: <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 09/02/2017 08:08 PM, Eric Sandeen wrote:
> On 9/2/17 9:48 PM, ToddAndMargo wrote:
>> Dear Xfs,
>>
>> Scientific Linux 7.3
>>
>> $ rpm -qa \*xfsdump\*
>> xfsdump-3.1.4-1.el7.x86_64
>>
>> When I do a backup to /dev/sda1 (/lin-bak), I get told
>>
>>      WARNING: Your hard drive is failing
>>      Device: /dev/sda [SAT], unable to open device
> 
> That's a message from smartctl, it has nothing to do with
> xfs or xfsdump.  It's probably related to your creative use
> of hotplug.
> 
> -Eric
> 

Then I am just going to ignore it then.

/dev/sda1 is always dismounted unless it is doing a backup
(or I am restoring something).  It is always dismounted
when I change it.

Thank you for the help!

