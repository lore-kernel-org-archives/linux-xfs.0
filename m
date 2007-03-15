Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 07:06:55 -0700 (PDT)
Received: from donner.stsci.edu (donner.stsci.edu [130.167.251.65])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FE6n6p031608
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 07:06:50 -0700
Message-ID: <45F952F2.6000008@stsci.edu>
Date: Thu, 15 Mar 2007 10:06:42 -0400
From: Thomas Walker <walker@stsci.edu>
MIME-Version: 1.0
Subject: Re: Should xfs_repair take this long?
References: <45F92D8C.3090708@stsci.edu> <20070315150422.7bc5d178@harpe.intellique.com>
In-Reply-To: <20070315150422.7bc5d178@harpe.intellique.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


     The terminal shows a lot of "." dots running across the screen 
quickly, and every few hours it says this;


.....................................................found candidate 
secondary superblock...
unable to verify superblock, continuing...
found candidate secondary superblock...
unable to verify superblock, continuing...

      Thomas Walker


Emmanuel Florac wrote:

>Le Thu, 15 Mar 2007 07:27:08 -0400
>Thomas Walker <walker@stsci.edu> écrivait:
>
>  
>
>>xfs_repair -o assume_xfs /dev/mapper/vg0-hladata3
>>
>>   This command has been running for two days now. 
>>    
>>
>
>Is there any output from xfs_repair ? This doesn't sound good. I've run
>xfs_repair on some badly corrupted fs up to 13 TB, and it never took
>more than a couple of minutes.
>
>  
>
