Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EBJKNN255520 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 05:19:20 -0600
Received: from omr5.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C99DD1657BE
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 03:20:11 -0800 (PST)
Received: from omr5.networksolutionsemail.com (omr5.networksolutionsemail.com
	[205.178.146.55]) by cuda.sgi.com with ESMTP id
	b7s5CQmkIz5hKg68 for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 03:20:11 -0800 (PST)
Received: from mail.networksolutionsemail.com (mail.networksolutionsemail.com
	[205.178.146.50])
	by omr5.networksolutionsemail.com (8.13.6/8.13.6) with SMTP id
	o0EBJtwv002382 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 06:20:05 -0500
Message-ID: <4B4EFDD5.5060408@chaven.com>
Date: Thu, 14 Jan 2010 05:19:49 -0600
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: XFS data corruption with high I/O even on hardware raid
References: <4B4E6F3F.1090901@chaven.com> <87hbqpf3zv.fsf@basil.nowhere.org>
In-Reply-To: <87hbqpf3zv.fsf@basil.nowhere.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2963085048905042835=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============2963085048905042835==
Content-Type: multipart/alternative;
 boundary="------------010000030903080708030007"

This is a multi-part message in MIME format.
--------------010000030903080708030007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It's the current kernel for the distribution, however I take your 
point.    I did have a 2.6.28 kernel running on another system that also 
exhibited the same problem but that system has been rebuilt to 
standardize them all on 8.04.3LTS.   I am contacting Areca to see if 
they have any suggestions as well as will try a newer kernel.


On 01/14/2010 03:08, Andi Kleen wrote:
> Steve Costaras<stevecs@chaven.com>  writes:
>    
>> ============ (System)
>> (Ubuntu 8.04.3 LTS):
>> Linux loki 2.6.24-26-server #1 SMP Tue Dec 1 18:26:43 UTC 2009 x86_64 GNU/Linux
>>      
> That's a really old kernel. Perhaps try it with a newer one?
>
> -Andi
>
>    

--------------010000030903080708030007
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Courier New">It's the current kernel for the distribution,
however I take your point.&nbsp;&nbsp;&nbsp; I did have a 2.6.28 kernel running on
another system that also exhibited the same problem but that system has
been rebuilt to standardize them all on 8.04.3LTS.&nbsp;&nbsp; I am contacting
Areca to see if they have any suggestions as well as will try a newer
kernel.<br>
<br>
</font><br>
On 01/14/2010 03:08, Andi Kleen wrote:
<blockquote cite="mid:87hbqpf3zv.fsf@basil.nowhere.org" type="cite">
  <pre wrap="">Steve Costaras <a class="moz-txt-link-rfc2396E" href="mailto:stevecs@chaven.com">&lt;stevecs@chaven.com&gt;</a> writes:
  </pre>
  <blockquote type="cite">
    <pre wrap="">
============ (System)
(Ubuntu 8.04.3 LTS):
Linux loki 2.6.24-26-server #1 SMP Tue Dec 1 18:26:43 UTC 2009 x86_64 GNU/Linux
    </pre>
  </blockquote>
  <pre wrap="">
That's a really old kernel. Perhaps try it with a newer one?

-Andi

  </pre>
</blockquote>
</body>
</html>

--------------010000030903080708030007--


--===============2963085048905042835==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2963085048905042835==--
