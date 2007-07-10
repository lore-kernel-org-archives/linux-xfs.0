Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 14:26:56 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6ALQrbm018709
	for <linux-xfs@oss.sgi.com>; Tue, 10 Jul 2007 14:26:53 -0700
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id 101F2908A5
	for <linux-xfs@oss.sgi.com>; Tue, 10 Jul 2007 14:08:30 -0700 (PDT)
Message-ID: <4693E877.4090409@sgi.com>
Date: Tue, 10 Jul 2007 15:13:43 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: usage pattern: xfsrestore to mirror disks
References: <f6r9pb$qv0$1@sea.gmane.org> <4691C1BA.4040603@sgi.com> <4693DCD6.2010106@hapra.at>
In-Reply-To: <4693DCD6.2010106@hapra.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jakob Praher <jp@hapra.at>
Cc: linux-xfs@oss.sgi.com

Hi Jakob,

If I'm understanding your issue correctly, it sounds like rsync would be
a good tool for your needs. Or is there some reason you're not using
rsync?

Bill

On 07/10/2007 02:24 PM, Jakob Praher wrote:
> Hi Timothy,
> 
> thanks for your quick response.
> I will apply your patch and try it out.
> 
> Timothy Shimmin wrote:
>> Hi Jakob,
>>  
>> I wonder if other tools might be useful to you... xfscopy,...?
>>
> that would be very interesting for me.
> 
> -- Jakob
>> --Tim
>>
>>
> 
>>
> 
