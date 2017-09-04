Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25428 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdIDFGX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 01:06:23 -0400
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
 <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
 <4741099f-1dcc-acff-46e1-61cd29ecf198@zoho.com>
 <6bae012e-5ac7-16d7-7ee6-da7b3729aa72@telefonica.net>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <2c1aaf9e-d8a3-d321-b8bf-e013e701175c@zoho.com>
Date: Sun, 3 Sep 2017 22:06:21 -0700
MIME-Version: 1.0
In-Reply-To: <6bae012e-5ac7-16d7-7ee6-da7b3729aa72@telefonica.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

On 09/03/2017 05:14 PM, Carlos E. R. wrote:
> On 2017-09-04 02:03, ToddAndMargo wrote:
>> On 09/03/2017 05:34 AM, Carlos E. R. wrote:
> 
> 
>>> So this is not a problem with XFS, but a problem caused by gparted
>>> (feature needed). You have to manually destroy key areas manually,
>>> probably just a few sectors at partition start.
>>>
>>>
>>
>> Thank you!  And something for 1478707 to reproduce!
> 
> If you are interested, these are the openSUSE bugzillas:
> 
> https://bugzilla.opensuse.org/show_bug.cgi?id=1046268
> USB Keys are mis-identified by device notifier
> 
> https://bugzilla.opensuse.org/show_bug.cgi?id=1046096
> Can't mount fat32 USB stick: issue on the partition table
> 

I added the second one to the read hat bug report.
Thank you!

