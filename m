Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93EE47F56
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 08:42:25 -0600 (CST)
Message-ID: <529361CD.7060902@sgi.com>
Date: Mon, 25 Nov 2013 08:42:21 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V4] xfsprogs: update version for 3.2.0-alpha2
References: <20131118150313.940966335@sgi.com>
	<20131122183757.113479216@sgi.com> <528FC827.7080100@redhat.com>
In-Reply-To: <528FC827.7080100@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7278591226031282434=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

--===============7278591226031282434==
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit


>
> <snip>
>
>>   xfsprogs-3.2.0-alpha1 (26 September 2013)
>> -	- Alpha release for the purpose of testing the CRC feature during the
>> -	  v3.12 kernel -rc series.
>> +	- Alpha release for the purpose of testing the CRC feature in
>> +	  kernels 3.10 and newer.
>> +	- Remove all vestiges of old, unsupported version 1 directory code.
>> +	- Add a “readdir” command to xfs_io, thanks to Brian Foster.
>                  ^^^       ^^
> That got a bit weird, probably my fault.
Will fix at commit time.

Need a 3rd party Reviewed-by: so I can get this committed please.

Thanks
--Rich
>
> Thanks,
> -Eric
 > <snip>


--===============7278591226031282434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7278591226031282434==--
